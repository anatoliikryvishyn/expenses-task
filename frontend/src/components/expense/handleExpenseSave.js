import request from "../../request";

export default async function handleExpenseSave(requestParams, setSaving, setExpense, notifyError) {
  try {
    setSaving(true);
    const { url, method, body } = requestParams

    const response = await request(url, {
      method,
      body,
    });
    if (response.ok) {
      setExpense(response.body);
    } else {
      notifyError("Failed to save expense. Please try again");
    }
  } catch (error) {
    notifyError(
      "Failed to save expense. Please check your internet connection"
    );
  } finally {
    setSaving(false);
  }
}