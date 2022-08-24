import React, { useEffect, useState } from "react";
import { useParams, useHistory } from "react-router-dom";
import request from "../../request";
import { useNotifications } from "../common/Notifications";
import loadPageContent from "../common/loadPageContent";
import AccountForm from "./AccountForm";
import handleAccountDelete from "./handleAccountDelete";
import handleAccountSave from "./handleAccountSave";

function AccountEdit() {
  const { id } = useParams();
  const history = useHistory();
  const [account, setAccount] = useState(null);
  const [loadingStatus, setLoadingStatus] = useState("loading");
  const [isSaving, setSaving] = useState(false);
  const [isDeleting, setDeleting] = useState(false);
  const { notifyError } = useNotifications();

  useEffect(
    function () {
      async function loadAccount() {
        try {
          const response = await request(`/accounts/${id}`, {
            method: "GET",
          });
          if (response.ok) {
            setAccount(response.body);
            setLoadingStatus("loaded");
          } else {
            setLoadingStatus("error");
          }
        } catch (error) {
          setLoadingStatus("error");
        }
      }
      if(id) {
        loadAccount();
      }
    },
    [id]
  );

  function handleSave(changes) {
    let requestParams = { 
      url: `/accounts/${account.id}`,
      method: "PATCH",
      body: changes
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

export default AccountEdit;
