<template>
    <div class="about">
      <div>
       <b><h1 style="color:#008000">Happy Banking!</h1></b>
      </div>
      <div>
       <strong style="color:#f5f5dc">We provide an awesome banking experience,<br>
         with a state on the art assistant available 24/7 for you.</strong>
      </div>
      <div>
        <button @click="count++">
          Count is: {{ count }}
        </button>
      </div>
    </div>
</template>

<script>

export default {
  // Properties returned from data() become reactive state
  // and will be exposed on `this`.
  data() {
    return {
      count: 0,
      }
  },

  // Methods are functions that mutate state and trigger updates.
  // They can be bound as event listeners in templates.
  methods: {
    increment() {
      this.count++
    }
  },
}
</script>

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
