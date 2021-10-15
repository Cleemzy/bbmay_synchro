defmodule Bebemayotte.Email do
  use Bamboo.Phoenix, view: BebemayotteView

  # CREATE NEW MAIL MESSAGE
  def new_mail_message(email, message) do
    new_email()
    |>from(email)
    |>to("nasolo@phidia.onmicrosoft.com")
    |>subject("Objet: MESSAGE D'UN CLIENT")
    |>text_body(message)
  end

end
