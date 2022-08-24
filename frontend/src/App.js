import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect,
  Link,
} from "react-router-dom";
import styles from "./App.module.css";
import ExpensesPage from "./components/expense/ExpensesPage";
import ExpenseEdit from "./components/expense/ExpenseEdit";
import ExpenseNew from "./components/expense/ExpenseNew";
import AccountsPage from "./components/account/AccountsPage";
import AccountEdit from "./components/account/AccountEdit";
import AccountNew from "./components/account/AccountNew";
import Notifications from "./components/common/Notifications";

function App() {
  return (
    <Router>
      <Notifications>
        <div className={styles.app}>
          <nav className={styles.mainNav}>
            <div className={styles.navInner}>
              <h1 className={styles.title}>Expense Tracker</h1>

              <ul>
                <li>
                  <Link to={"/"}>Expenses</Link>
                </li>
                <li>
                  <Link to={"/accounts"}>Accounts</Link>
                </li>
              </ul>
            </div>
          </nav>

          <main className={styles.main}>
            <Switch>
              <Route exact path={"/"}>
                <Redirect to={"/expenses"} />
              </Route>
              <Route exact path={"/expenses"}>
                <ExpensesPage />
              </Route>
              <Route exact path={"/expense/new"}>
                <ExpenseNew />
              </Route>
              <Route exact path={"/expense/:id"}>
                <ExpenseEdit />
              </Route>
              <Route exact path={"/accounts"}>
                <AccountsPage />
              </Route>
              <Route exact path={"/accounts/new"}>
                <AccountNew />
              </Route>
              <Route exact path={"/accounts/:id"}>
                <AccountEdit />
              </Route>
            </Switch>
          </main>
        </div>
      </Notifications>
    </Router>
  );
}

export default App;
