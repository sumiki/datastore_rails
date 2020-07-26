<template>
  <div class="m-10">
    Account {{accountId}}
  </div>
</template>

<script>
export default {
  props: ['accountId'],
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
