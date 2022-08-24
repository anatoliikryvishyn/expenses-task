import React, { useEffect, useState } from "react";
import { useParams, useHistory } from "react-router-dom";
import request from "../../request";
import { useNotifications } from "../common/Notifications";
import loadPageContent from "../common/loadPageContent";
import handleExpenseDelete from "./handleExpenseDelete";
import handleExpenseSave from "./handleExpenseSave";
import ExpenseForm from "./ExpenseForm";

function ExpenseEdit() {
  const { id } = useParams();
  const history = useHistory();
  const [expense, setExpense] = useState(null);
  const [accounts, setAccounts] = useState([])
  const [loadingStatus, setLoadingStatus] = useState("loading");
  const [isSaving, setSaving] = useState(false);
  const [isDeleting, setDeleting] = useState(false);
  const { notifyError } = useNotifications();

  useEffect(
    function () {
      async function loadData() {
        try {
          const expenseResp = await request(`/expenses/${id}`, {
            method: "GET",
          });
          const accountsResp = await request(`/accounts`, {
            method: "GET",
          });
          if (accountsResp.ok && expenseResp.ok) {
            setExpense(expenseResp.body)
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
      url: `/expenses/${expense.id}`,
      method: "PATCH",
      body: changes
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

export default ExpenseEdit;
