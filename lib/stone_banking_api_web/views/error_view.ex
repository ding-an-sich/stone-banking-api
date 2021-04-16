defmodule StoneBankingAPIWeb.ErrorView do
  use StoneBankingAPIWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("400.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def render("400.json", %{type: type}) do
    %{errors: %{detail: Atom.to_string(type)}}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
