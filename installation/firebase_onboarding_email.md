# Firebase onboarding email

You can setup this custom onboarding email, that will be sent to every user added to your Marble instance.

To add it:

  1. Go to your Firebase project homepage.
  2. Access Build → Authentication. If you have not setup this yet, you will need to click on "Get started".
  3. In the menu, select "Password reset".
  4. Setup the sender name, email, reply to and subject.
  5. Copy the following html code and paste it into the "Message section".

```html
<!DOCTYPE html>
<html lang="en">
  <body style="margin: 0; padding: 0; background-color: #EEEDFF; font-family: Inter, Arial, sans-serif;">
    <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #EEEDFF; padding: 40px 0;">
      <tr>
        <td align="center">
          <table width="100%" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; overflow: hidden;" cellpadding="0" cellspacing="0">
            <tr style="background-color: #5A50FA;">
              <td align="center" style="padding: 20px;">
                <img src="https://lh3.googleusercontent.com/d/1_MwpADEU26gZWUZcKcl57e8G5FI8FIXn" alt="Marble Logo" width="40" height="40" style="display: block;">
              </td>
            </tr>
            <tr>
              <td style="padding: 10px;">
                <h2 align="center" style="color: #1c1c1c;">Welcome to Marble !</h2>
                <p style="color: #333333; font-size: 16px; line-height: 24px;">
                  You've been granted access to Marble. Please choose one of the following options to access your account:
                </p>

                <!-- Buttons -->
                <table width="100%" cellspacing="0" cellpadding="0" style="margin: 20px 0;">
                  <tr>
                    <td align="center" style="padding-bottom: 10px;">
                      <a href="https://checkmarble.com" style="background-color: #5A50FA; color: #ffffff; padding: 8px 24px; border-radius: 4px; text-decoration: none; font-weight: normal;font-size: 14px; display: inline-block;">
                        Sign in with Google or Microsoft
                      </a>
                    </td>
                  </tr>
                  <tr>
                    <td align="center">
                      <a href="%LINK%" style="background-color: #ffffff; color: #5A50FA; padding: 8px 24px; border: 2px solid #5A50FA; border-radius: 4px; text-decoration: none; font-weight: normal; font-size: 14px;display: inline-block;">
                        Create your password manually
                      </a>
                    </td>
                  </tr>
                </table>

                <hr style="border: none; border-top: 1px solid #e0e0e0; margin: 20px 0;">

                <p style="color: #333333; font-size: 16px; line-height: 24px;">
                  If you requested a password reset, click the button below:
                </p>

                <p style="text-align: center; margin: 10px 0;">
                  <a href="%LINK%" style="background-color: #5A50FA; color: #ffffff; padding: 8px 24px; border-radius: 4px; text-decoration: none; font-weight: normal; font-size: 14px; display: inline-block;">
                    Reset your password
                  </a>
                </p>

                <p style="color: #666666; font-size: 14px; line-height: 22px;">
                  If you didn't request a password reset, you can safely ignore this message.
                </p>
                <p style="margin-top: 20px; color: #333333; font-size: 16px;">Have a great day !<br></p>
                <p style="margin-top: 20px; color: #333333; font-size: 16px;font-weight: bold;"> Marble team</p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
'''
