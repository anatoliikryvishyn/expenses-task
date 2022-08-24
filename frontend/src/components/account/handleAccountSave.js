import request from "../../request";

export default async function handleAccountSave(requestParams, setSaving, setAccount, notifyError) {
  try {
    setSaving(true);
    const { url, method, body } = requestParams

    const response = await request(url, {
      method,
      body,
    });
    if (response.ok) {
      setAccount(response.body);
    } else {
      notifyError("Failed to save account. Please try again");
    }
  } catch (error) {
    notifyError(
      "Failed to save account. Please check your internet connection"
    );
  } finally {
    setSaving(false);
  }
}