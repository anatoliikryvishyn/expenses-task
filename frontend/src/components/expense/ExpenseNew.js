import React, { useEffect, useState } from "react";
import { useParams, useHistory } from "react-router-dom";
import request from "../../request";
import { useNotifications } from "../common/Notifications";
import loadPageContent from "../common/loadPageContent";
import handleExpenseDelete from "./handleExpenseDelete";
import handleExpenseSave from "./handleExpenseSave";
import ExpenseForm from "./ExpenseForm";

const defaultExpenseData = {
  amount: 0,
  date: new Date().toISOString().substr(0, 10),
  description: "",
};

function ExpenseNew() {
  const { id } = useParams();
  const history = useHistory();
  const [expense, setExpense] = useState(defaultExpenseData);
  const [accounts, setAccounts] = useState([])
  const [loadingStatus, setLoadingStatus] = useState("loaded");
  const [isSaving, setSaving] = useState(false);
  const [isDeleting, setDeleting] = useState(false);
  const { notifyError } = useNotifications();

  useEffect(
    function () {
      async function loadData() {
        try {
          const accountsResp = await request(`/accounts`, {
            method: "GET",
          });
          if (accountsResp.ok) {
            setAccounts(accountsResp.body)
            
            setLoadingStatus("loaded");
          } else {
            setLoadingStatus("error");
          }
        } catch (error) {
          setLoadingStatus("error");
        }
      }

      loadData();
    },
    [id]
  );

  function handleSave(changes) {
    let requestParams = { 
      url: "/expenses",
      method: "POST",
      body: { ...defaultExpenseData, ...changes }
   }
    handleExpenseSave(requestParams, setSaving, setExpense, notifyError)
  }

  function handleDelete() {
    handleExpenseDelete(expense.id, setDeleting, history, notifyError)
  }

  let mainContent = loadingStatus == "loaded" && <ExpenseForm
    key={expense.updated_at}
    expense={expense}
    accounts={accounts}
    onSave={handleSave}
    disabled={isSaving || isDeleting}
    onDelete={handleDelete}
  />;

  return <div>{loadPageContent(loadingStatus, mainContent)}</div>;
}

export default ExpenseNew;
