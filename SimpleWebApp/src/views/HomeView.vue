<script setup>
import TheWelcome from "../components/TheWelcome.vue";

console.log("-->log ASSISTANT_INTEGRATION_ID : " + window.ASSISTANT_INTEGRATION_ID );
console.log("-->log ASSISTANT_REGION : " + window.ASSISTANT_REGION);
console.log("-->log ASSISTANT_SERVICE_INSTANCE_ID : " + window.ASSISTANT_SERVICE_INSTANCE_ID);

// Your custom service desk integration which can be located anywhere in your codebase.
class MyServiceDesk {
    constructor(callback) {
      this.callback = callback;
    }
    startChat() {
      console.log('Starting chat');
    }
    endChat() {
      console.log('Ending chat');
    }
    sendMessageToAgent() {
      console.log('Sending message to agent');
    }
}

window.watsonAssistantChatOptions = {
  integrationID: window.ASSISTANT_INTEGRATION_ID, // The ID of this integration.
  region: window.ASSISTANT_REGION, // The region your integration is hosted in.
  serviceInstanceID: window.ASSISTANT_SERVICE_INSTANCE_ID, // The ID of your service instance.
  onLoad: function (instance) {
    instance.render();
  },

  // **** The important part. This creates an instance of your integration.
  serviceDeskFactory: (parameters) => new MyServiceDesk(parameters.callback),
};

setTimeout(function () {
  const t = document.createElement("script");
  t.src =
    "https://web-chat.global.assistant.watson.appdomain.cloud/versions/" +
    (window.watsonAssistantChatOptions.clientVersion || "latest") +
    "/WatsonAssistantChatEntry.js";
  document.head.appendChild(t);
});
</script>

<template>
  <body>
    <main>
      <TheWelcome />
    </main>
  </body>
</template>

<style>
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    align-items: center;
  }
}

body {
 background-image: url("../assets/money-2696229_1920.jpg");
 background-color: #cccccc;
}

header {
  line-height: 1.5;
  max-height: 100vh;
}

</style>
