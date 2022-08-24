import React from "react";
import styles from "./Page.module.css";

function NoRecordsPage({message, button}) {
  return(
    <div className={styles.emptyState}>
    <div className={styles.emptyStateMessage}>
      {message}
    </div>
    <div>{button}</div>
  </div>
  )
}

export default NoRecordsPage;