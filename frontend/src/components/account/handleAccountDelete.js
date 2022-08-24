import request from "../../request";

export default async function handleDelete(accountId, setDeleting, history, notifyError) {
  setDeleting(true);
  try {
    const response = await request(`/accounts/${accountId}`, {
      method: "DELETE",
    });
    if (response.ok) {
      history.push("/accounts");
    } else {
      notifyError("Failed to delete account. Please try again");
    }
  } catch (error) {
    notifyError(
      "Failed to delete account. Please check your internet connection"
    );
  } finally {
    setDeleting(false);
  }
}
