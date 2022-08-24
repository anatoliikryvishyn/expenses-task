import React, { useState } from "react";
import styles from "../common/Form.module.css";
import Button from "../common/Button";

function AccountForm({ account, onSave, disabled, onDelete }) {
  const [changes, setChanges] = useState({});

  function changeField(field, value) {
    setChanges({
      ...changes,
      [field]: value,
    });
  }

  const formData = {
    ...account,
    ...changes,
  };

  function handleSubmit(event) {
    event.preventDefault();
    onSave(changes);
  }

  return (
    <form autoComplete={"off"} onSubmit={handleSubmit} className={styles.form}>
      <fieldset disabled={disabled ? "disabled" : undefined}>
        <div className={styles.formRow}>
          <label htmlFor="name">Name</label>
          <input
            required
            id={"name"}
            type={"text"}
            value={formData.name}
            onChange={(event) => changeField("name", event.target.value)}
          />
        </div>
        <div className={styles.formRow}>
          <label htmlFor="number">Bank account number</label>
          <input
            required
            id={"number"}
            type={"text"}
            value={formData.number}
            onChange={(event) => changeField("number", event.target.value)}
          />
        </div>
      </fieldset>

      <div className={styles.formFooter}>
        {account.id && (
          <Button action={onDelete} kind={"danger"} disabled={disabled}>
            Delete
          </Button>
        )}
        <Button
          type={"submit"}
          disabled={Object.keys(changes).length === 0 || disabled}
        >
          Save
        </Button>
      </div>
    </form>
  );
}

export default AccountForm;