import React, { useEffect, useState } from "react";
import { useParams, useHistory } from "react-router-dom";
import { useNotifications } from "../common/Notifications";
import loadPageContent from "../common/loadPageContent";
import AccountForm from "./AccountForm";
import handleAccountDelete from "./handleAccountDelete";
import handleAccountSave from "./handleAccountSave";

const defaultAccountData = {
  name: "",
  number: "",
};

function AccountNew() {
  const { id } = useParams();
  const history = useHistory();
  const [account, setAccount] = useState(defaultAccountData);
  const [loadingStatus, setLoadingStatus] = useState("loaded");
  const [isSaving, setSaving] = useState(false);
  const [isDeleting, setDeleting] = useState(false);
  const { notifyError } = useNotifications();

  function handleSave(changes) {
    let requestParams = { 
      url: "/accounts",
      method: "POST",
      body: { ...defaultAccountData, ...changes }
   }
    handleAccountSave(requestParams, setSaving, setAccount, notifyError)
  }

  function handleDelete() {
    handleAccountDelete(account.id, setDeleting, history, notifyError)
  }

  let mainContent = loadingStatus == "loaded" && <AccountForm
    key={account.updated_at}
    account={account}
    onSave={handleSave}
    disabled={isSaving || isDeleting}
    onDelete={handleDelete}
  />;

  return <div>{loadPageContent(loadingStatus, mainContent)}</div>;
}

export default AccountNew;
