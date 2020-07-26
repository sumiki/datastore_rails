<template>
  <div class="m-10">
    Account {{accountId}}
  </div>
</template>

<script>

import { ALL_HOLDINGS_QUERY } from '../constants/graphql'

export default {
  props: ['accountId'],
  data () {
    return {
      allHoldings: [],
      loading: 0
    }
  },
  apollo: {
    allHoldings: {
      query: ALL_HOLDINGS_QUERY,
      variables: {
        accountId: 49,
      }
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
