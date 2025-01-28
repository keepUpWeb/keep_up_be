export function generateConfirmationEmailContent(
  userName: string,
  confirmationLink: string,
): string {
  return `
      <html>
        <head>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f4;
              margin: 0;
              padding: 20px;
            }
            .container {
              background-color: #fff;
              padding: 20px;
              border-radius: 5px;
              box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
              color: #333;
            }
            p {
              color: #555;
            }
            .button {
              display: inline-block;
              padding: 10px 20px;
              margin-top: 15px;
              background-color: #28a745;
              color: white;
              text-decoration: none;
              border-radius: 5px;
            }
            .footer {
              margin-top: 20px;
              font-size: 12px;
              color: #777;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>Welcome to KeepUp, ${userName}!</h1>
            <p>Thank you for registering with KeepUp. We're excited to have you on board!</p>
            <p>Please confirm your email address by clicking the button below:</p>
            <a href="${confirmationLink}" class="button">Confirm Email</a>
            <p>If you did not register for this account, please ignore this email.</p>
            <div class="footer">
              <p>Best regards,<br>The KeepUp Team</p>
            </div>
          </div>
        </body>
      </html>
    `;
}
