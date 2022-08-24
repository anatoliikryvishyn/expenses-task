import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import LoadingIndicator from "../common/LoadingIndicator";
import ErrorMessage from "../common/ErrorMessage";
import request from "../../request";
import styles from "../common/Page.module.css";
import Button from "../common/Button";
import NoRecordsPage from "../common/NoRecordsPage";
import loadPageContent from "../common/loadPageContent";

function ExpenseRow({ expense }) {
  return (
    <li className={styles.item}>
      <Link to={`/expense/${expense.id}`} className={styles.itemInner}>
        <div className={styles.descriptionText}>{expense.description}</div>
        <div className={styles.amountText}>${expense.amount.toFixed(2)}</div>
      </Link>
    </li>
  );
}

function ExpenseList({ expenses }) {
  const newExpenseButton = <Button to={"/expense/new"}>New Expense</Button>;
  
  if (expenses.length === 0) {
    return (
      <NoRecordsPage message="You haven't recorded any expenses" button={newExpenseButton} />
    );
  }

  return (
    <>
      <ul className={styles.list}>
        {expenses.map((expense) => (
          <ExpenseRow key={expense.id} expense={expense} />
        ))}
      </ul>

      <div className={styles.actions}>{newExpenseButton}</div>
    </>
  );
}

function ExpensesPage() {
  const [expenses, setExpenses] = useState([]);
  const [status, setStatus] = useState("loading");

  useEffect(function () {
    async function loadExpenses() {
      const response = await request("/expenses", {
        method: "GET",
      });
      if (response.ok) {
        setExpenses(response.body);
        setStatus("loaded");
      } else {
        setStatus("error");
      }
    }

    loadExpenses();
  }, []);

  return loadPageContent(status, <ExpenseList expenses={expenses} />);
}

export default ExpensesPage;
