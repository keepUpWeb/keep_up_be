import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';
import { StatistikKuisioner } from 'src/common/interfaces/StatistikKuisioner.interface';
import { Background, PreKuisionerAnswer, ReportData, SymptomResult } from 'src/take-kuisioner/take-kuisioner.model';

@Injectable()
export class AikeepUpService {
  private openai: OpenAI;
  private openAiModel: string;
  private maxTokens: number;
  private temperature: number;

  constructor(private configService: ConfigService) {
    this.openai = new OpenAI({
      apiKey: this.configService.get<string>('openai.apiKey'),
    });
    // Load configuration once in the constructor for better efficiency
    this.openAiModel = this.configService.get<string>('openai.model');
    this.maxTokens = this.configService.get<number>('openai.maxTokens');
    this.temperature = this.configService.get<number>('openai.temperature');
  }


  // Private function for making OpenAI chat completions requests
  private async openAiRequest(prompt: string, systemMessage: string): Promise<string> {
    try {
      const response = await this.openai.chat.completions.create({
        model: this.openAiModel,
        messages: [
          {
            role: 'system',
            content: systemMessage,
          },
          {
            role: 'user',
            content: prompt,
          },
        ],
        max_tokens: this.maxTokens,
        temperature: this.temperature,
      });

      return response.choices[0].message.content.trim();
    } catch (error) {
      throw new Error(`OpenAI request failed: ${error.message}`);
    }
  }


  async generateSumarize(data: StatistikKuisioner): Promise<string> {
    try {
      const gptPrompt = `
    Berikut adalah hasil kuisioner yang berisi data terkait gejala-gejala Stress, Depresi, Prokrastinasi, Kecanduan Ponsel, dan Kecemasan yang dialami oleh para responden. Harap berikan ringkasan yang padat dan jelas mengenai temuan utama yang relevan untuk pemangku kepentingan, dengan penekanan pada pola umum gejala dan tingkat keparahannya.

    Data Kuisioner:
    ${data.UserSymptomStatistics.map((kuisioner, index) => `
    Responden ${index + 1}:
    - Kuisioner: ${kuisioner.kuisionerName}
    - Gejala yang Teramati:
    ${Object.entries(kuisioner.symptoms).map(
    ([symptom, details]) => `
        -- ${symptom}: 
          --- Tingkat Keparahan: ${details.level}`
    ).join('\n')}`
    ).join('\n\n')}

    Instruksi untuk merangkum:  
    1. Berikan jumlah pengisi.
    2. Fokus pada gejala-gejala dengan tingkat keparahan tertinggi yang muncul secara konsisten di antara para responden.
    3. Identifikasi pola umum gejala dan prevalensinya di seluruh responden.
    4. Berikan analisis yang jelas tentang temuan utama dan gambaran umum mengenai gejala yang perlu mendapat perhatian lebih.
    5. Tulis ringkasan dengan bahasa profesional, singkat, dan langsung ke pokok permasalahan, tanpa menyebutkan nama responden atau informasi pribadi.
    6. Hindari penjelasan yang bertele-tele, cukup fokus pada temuan penting dan kesimpulan yang relevan untuk pengambilan keputusan.

    Ringkasan ini harus disusun dengan cara yang mudah dipahami oleh manajer atau atasan yang memerlukan informasi utama untuk analisis lebih lanjut dan tindakan yang tepat.

    `;



      const gptSystem = `
        Anda adalah asisten yang terlatih dalam menganalisis dan merangkum data hasil kuisioner. Tujuan Anda adalah memberikan ringkasan yang terstruktur, profesional, dan mudah dipahami terkait gejala-gejala seperti Stress, Depresi, Prokrastinasi, Kecanduan Ponsel, dan Kecemasan. Pastikan rangkuman mencakup:
        1. Gejala-gejala utama yang perlu menjadi perhatian pemilik kuisioner berdasarkan tingkat keparahan dan frekuensinya.
        2. Pola gejala yang sering muncul di antara seluruh responden.
        3. Kesimpulan atau rekomendasi yang dapat membantu pihak yang bertanggung jawab untuk memahami data ini lebih baik.
        Gunakan bahasa yang sopan, profesional, dan jelas, dengan fokus pada analisis umum dan pola gejala tanpa menyebutkan nama atau informasi spesifik responden.

        `;

      return await this.openAiRequest(gptPrompt, gptSystem);
    } catch (error) {
      console.error("Error generating summary:", error);
      throw new Error("Gagal menghasilkan ringkasan. Mohon coba lagi nanti.");
    }
  }




  async generateReport(data: ReportData): Promise<string> {
    try {
      const gptPrompt = `
      Buat analisis psikologis dalam bahasa Indonesia berdasarkan data yang disediakan di bawah ini. Analisis harus disusun seperti bercerita tentang apa yang terjadi pada individu. Gunakan gaya bahasa yang santai namun tetap informatif, sehingga pembaca merasa terhubung dengan isi. Hasil analisis harus berupa teks biasa tanpa format khusus, disusun dalam dua paragraf untuk setiap gejala:
      - Paragraf pertama: Ceritakan secara naratif tentang apa yang dialami individu berdasarkan skor dan tingkatannya.
      - Paragraf kedua: Berikan rekomendasi praktis yang dapat dilakukan oleh mahasiswa untuk mengelola gejala tersebut.

      Gunakan bahasa Indonesia yang mudah dipahami, tanpa istilah teknis yang rumit. Jika terdapat istilah asing, berikan penjelasan singkat dalam kalimat. Pastikan analisis tetap ringkas, nyaman dibaca, dan terasa seperti percakapan yang hangat namun tetap relevan.

      ### Instruksi:
      1. Analisis hanya gejala dan hasil yang disediakan dalam bagian "Data". Bagian "Latar Belakang" hanya untuk konteks dan tidak perlu dianalisis.
      2. Untuk setiap gejala, sediakan:
        - Penjelasan naratif tentang gejala dan dampaknya (paragraf pertama).
        - Rekomendasi praktis yang dirancang untuk mahasiswa (paragraf kedua).
      3. Akhiri dengan bagian "Kesimpulan" yang merangkum analisis keseluruhan dan langkah yang disarankan.

      ### Format Data:
      1. *Gejala* meliputi "Depresi", "Kecemasan", "Stres", "Prokrastinasi", dan "Kecanduan Ponsel".
      2. Berikan analisis untuk setiap gejala meskipun rekomendasi tertentu tidak dapat diberikan.

      ### Data untuk Analisis:
      Latar Belakang:
      ${data.background.map(
        (item) => `
        - Kategori: ${item.categoryName}
        ${item.preKuisionerAnswer.map(
          (dataBackground) => `
          - Pertanyaan: ${dataBackground.question}
          - Jawaban: ${dataBackground.answer}`
        ).join('\n')}
        `
      ).join('\n')}

      Data:
      ${data.result.map(
        (item) => `
        - Nama: ${item.nameSymtomp}
        - Tingkat: ${item.level}
        - Skor: ${item.score}`
      ).join('\n')}

      ### Contoh Tanggapan:
      Kecemasan
      Kecemasan dengan skor 25 (kategori sangat tinggi) menandakan bahwa klien mungkin sering mengalami perasaan gelisah, tegang, dan khawatir berlebihan. Dampaknya meliputi gangguan tidur, sulit berkonsentrasi, dan kelelahan mental serta fisik. Direkomendasikan untuk mencoba teknik relaksasi seperti pernapasan dalam, serta konseling untuk menangani penyebab utama kecemasan.

      Stres
      Stres dengan skor 30 (kategori sangat tinggi) menunjukkan bahwa klien mengalami tekanan emosional yang signifikan, yang dapat memengaruhi kesejahteraan mental dan fisik secara serius. Dampaknya termasuk kelelahan kronis, gangguan tidur, dan kesulitan dalam menyelesaikan tugas-tugas sehari-hari. Tingginya tingkat stres ini juga bisa memperburuk gejala kecemasan dan depresi, serta mengurangi kemampuan klien untuk berfungsi secara efektif dalam konteks akademik dan sosial.

      Prokrastinasi
      Prokrastinasi yang tinggi pada klien dapat berdampak pada penundaan penyelesaian tugas akademik, yang pada gilirannya meningkatkan stres dan kecemasan. Kebiasaan menunda-nunda ini bisa memicu siklus negatif di mana tugas yang belum terselesaikan menjadi sumber tekanan tambahan, yang pada akhirnya mengurangi produktivitas dan kualitas hasil akademik.
          
      Kecanduan Ponsel
      Kecanduan ponsel yang berada pada kategori sedang, hal ini berisiko mengganggu waktu produktif klien, mengurangi efisiensi belajar, serta memengaruhi kualitas interaksi sosial. Ketergantungan pada ponsel juga dapat meningkatkan prokrastinasi, karena waktu yang dihabiskan untuk penggunaan ponsel dapat mengalihkan fokus dari tugas-tugas penting, dan pada akhirnya meningkatkan tingkat stres.
          
      Kesimpulan
      Secara keseluruhan, kondisi mental yang dialami oleh klien menunjukkan perlunya intervensi menyeluruh. Kombinasi dari konseling psikologis, pelatihan manajemen waktu, dan strategi coping dapat membantu klien mengelola gejala secara efektif dan meningkatkan kualitas hidup.

      `


      const gptSystem = "You are a highly skilled psychologist specializing in analyzing patient conditions based on questionnaire responses. Your role is to generate detailed, empathetic, and well-structured psychological analysis reports based on the provided data. Your reports should offer in-depth insights into each symptom, its potential effects, and recommendations for intervention, using a formal and empathetic tone suitable for patients and their needs. Please ensure the output is plain text, with no special formatting such as **bold**."



      // Extract and format the response content, ensuring plain text output
      const generatedReport = await this.openAiRequest(gptPrompt, gptSystem)
      return generatedReport;
    } catch (error) {
      console.error('Error generating report from OpenAI:', error);
      throw new Error(`Failed to generate report from OpenAI: ${error.message}`);
    }
  }



}
