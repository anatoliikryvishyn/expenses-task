import request from "../../request";

export default async function handleDelete(expenseId, setDeleting, history, notifyError) {
  setDeleting(true);
  try {
    const response = await request(`/expenses/${expenseId}`, {
      method: "DELETE",
    });
    if (response.ok) {
      history.push("/expenses");
    } else {
      notifyError("Failed to delete account. Please try again");
    }
  } catch (error) {
    notifyError(
      "Failed to delete expense. Please check your internet connection"
    );
  } finally {
    setDeleting(false);
  }
}
