<template>
  <div class="m-10">
    <div class="flex">
      <div class="flex-grow">Account {{accountId}}</div>
      <button
          @click="openHoldingModal"
          class="flex-grow-0 bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
      >
        Button
      </button>
    </div>
    <table>
      <th>
        <td>Ticker</td>
        <td>Name</td>
        <td>Count</td>
      </th>
      <tr v-for="holding in allHoldings">
        <td><div v-text="holding.tickerSymbol"></div></td>
        <td><div v-text="holding.name"></div></td>
        <td><div v-text="holding.count"></div></td>
      </tr>
    </table>
    <HoldingForm
        v-if="modalHoldingFlag"
        @closeHoldingModal="closeHoldingModal"
    ></HoldingForm>
  </div>
</template>

<script>

import { ALL_HOLDINGS_QUERY } from '../constants/graphql'
import HoldingForm from './holding_form'

export default {
  props: ['accountId'],
  components: {
    HoldingForm
  },
  data () {
    return {
      allHoldings: [],
      loading: 0,
      modalHoldingFlag: false,
    }
  },
  methods: {
    openHoldingModal: function (event) {
      this.modalHoldingFlag = true
    },
    closeHoldingModal: function(event) {
      this.modalHoldingFlag = false
    }
  },
  apollo: {
    allHoldings: {
      query: ALL_HOLDINGS_QUERY,
      variables: function(){
        return {accountId: this.accountId}
      }
    }
  }
}
</script>

<style scoped>

</style>
