window.watsonAssistantChatOptions = {
    integrationID: "fb6dac0e-7249-4461-bf19-798d3b68505b", // The ID of this integration.
    region: "us-south", // The region your integration is hosted in.
    serviceInstanceID: "07061aa9-b6d8-427d-af36-947da5f8a12e", // The ID of your service instance.
    onLoad: function(instance) { instance.render(); }
};
setTimeout(function(){
    const t=document.createElement('script');
    t.src="https://web-chat.global.assistant.watson.appdomain.cloud/versions/" + (window.watsonAssistantChatOptions.clientVersion || 'latest') + "/WatsonAssistantChatEntry.js";
    document.head.appendChild(t);
});
