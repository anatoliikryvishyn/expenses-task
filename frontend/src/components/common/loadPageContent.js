import React, { useEffect, useState } from "react";
import LoadingIndicator from "./LoadingIndicator"
import ErrorMessage from "./ErrorMessage"

export default function loadPageContent(status, mainContent) {
  let content;
  if (status === "loading") {
    content = <LoadingIndicator />;
  } else if (status === "loaded") {
    content = mainContent;
  } else if (status === "error") {
    content = <ErrorMessage />;
  } else {
    throw new Error(`Unexpected status: ${status}`);
  }

  return content;
}
