import { PreKuisionerUser } from "src/pre-kuisioner-user/entities/pre-kuisioner-user.entity";


export function transformPreKuisionerUserAnswerFromEntity(userWithAnswers: PreKuisionerUser) {
    // Group answers by category
    const groupedByCategory = userWithAnswers.preKuisionerUserAnswer.reduce((acc, answer) => {
        const categoryId = answer.preKuisionerAnswer.preQuestionId.category.id; // Replace with actual category ID property
        const categoryName = answer.preKuisionerAnswer.preQuestionId.category.name; // Replace with actual category name property

        // Find existing category group or create a new one
        let categoryGroup = acc.find(group => group.categoryId === categoryId);
        if (!categoryGroup) {
            categoryGroup = {
                categoryId,
                categoryName,
                preKuisionerAnswer: [],
            };
            acc.push(categoryGroup);
        }

        // Add the answer to the corresponding category group
        categoryGroup.preKuisionerAnswer.push(answer);

        return acc;
    }, []);

    // Return the transformed data structure
    return {
        ...userWithAnswers,
        preKuisionerUserAnswer: groupedByCategory,
    };

}