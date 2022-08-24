import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import LoadingIndicator from "../common/LoadingIndicator";
import ErrorMessage from "../common/ErrorMessage";
import request from "../../request";
import styles from "../common/Page.module.css";
import Button from "../common/Button";
import NoRecordsPage from "../common/NoRecordsPage";
import loadPageContent from "../common/loadPageContent";

function AccountRow({ account }) {
  return (
    <li className={styles.item}>
      <Link to={`/accounts/${account.id}`} className={styles.itemInner}>
        <div className={styles.descriptionText}>{account.name}</div>
        <div className={styles.amountText}>${account.balance.toFixed(2)}</div>
      </Link>
    </li>
  );
}

function AccountList({ accounts }) {
  const newAccountButton = <Button to={"/accounts/new"}>New Account</Button>;

  if (accounts.length === 0) {
    return (
      <NoRecordsPage message="You haven't recorded any accounts" button={newAccountButton} />
    );
  }

  return (
    <>
      <ul className={styles.list}>
        {accounts.map((account) => (
          <AccountRow key={account.id} account={account} />
        ))}
      </ul>

      <div className={styles.actions}>{newAccountButton}</div>
    </>
  );
}

function AccountsPage() {
  const [accounts, setAccounts] = useState([]);
  const [status, setStatus] = useState("loading");

  useEffect(function () {
    async function loadAccounts() {
      const response = await request("/accounts", {
        method: "GET",
      });
      if (response.ok) {
        setAccounts(response.body);
        setStatus("loaded");
      } else {
        setStatus("error");
      }
    }

    loadAccounts();
  }, []);

  return loadPageContent(status, <AccountList accounts={accounts} />);
}

export default AccountsPage;
