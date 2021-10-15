defmodule Email do
  use Bamboo.Phoenix, view: Bebemayotte.EmailView

  def welcome_text_email(email_address) do
    body = "
          welcom to my app!!!

          you fucking bitch!!!
          "
    new_email()
    |> to(email_address)
    |> from("sandaranarijaona@gmail.com")
    |> subject("Welcome!")
    |> text_body(body)
  end
end
