<template>
  <div class="m-10">
    <div class="flex">
      <div class="flex-grow">Account {{accountId}}</div>
      <button
          @click="openHoldingModal"
          class="flex-grow-0 bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
      >
        Purchase
      </button>
    </div>
    <table class="text-left w-full border-collapse">
      <tr>
        <th :class="tableThStyle">Ticker</th>
        <th :class="tableThStyle">Name</th>
        <th :class="tableThStyle">Count</th>
        <th :class="tableThStyle">Details</th>
      </tr>
      <tr v-for="holding in allHoldings" :class="tableTrStyle">
        <td :class="tableTdStyle"><div v-text="holding.tickerSymbol"></div></td>
        <td :class="tableTdStyle"><div v-text="holding.name"></div></td>
        <td :class="tableTdStyle">{{ `${holding.holdingCount} / ${holding.totalCount}` }}</td>
        <td :class="tableTdStyle">
          <table>
            <tr v-for="detail in holding.aggregateDetails">
              <td :class="detailTdDate" v-text="detail.purchaseDate"></td>
              <td :class="detailTdCount" v-text="detail.count"></td>
              <td :class="detailTdPrice" v-text="detail.purchasePrice"></td>
              <td :class="detailTdPrice" v-text="detail.purchasePriceTotal"></td>
              <td :class="detailTdAction">
                <div v-if="!!!detail.soldDate">
                  <button
                      @click="(e) => { openSellingModal( e, holding, detail) }"
                      class="flex-grow-0 bg-blue-500 hover:bg-blue-600 text-white font-bold py-1 px-2 rounded"
                  >
                    Sell
                  </button>
                </div>
                <div v-else>
                  <span v-text="detail.soldDate"></span> <span v-text="detail.soldPrice"></span>
                </div>

              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <HoldingForm
        v-if="modalHoldingFlag"
        :accountId="accountId"
        @closeHoldingModal="closeHoldingModal"
    ></HoldingForm>
    <SellingForm
      v-if="modalSellingFlag"
      :accountId="accountId"
      :holding="modalSellingHolding"
      :aggDetail="modalSellingDetail"
      @closeSellingModal="closeSellingModal"
    >
    </SellingForm>

  </div>
</template>

<script>

import { ALL_HOLDINGS_QUERY } from '../constants/graphql'
import HoldingForm from './holding_form'
import SellingForm from './selling_form'

export default {
  props: ['accountId'],
  components: {
    HoldingForm,
    SellingForm,
  },
  data () {
    return {
      allHoldings: [],
      loading: 0,
      modalHoldingFlag: false,
      modalSellingFlag: false,
      modalSellingHolding: null,
      modalSellingDetail: null,
    }
  },
  computed: {
    tableThStyle(){
      return 'py-4 px-6 bg-grey-lightest font-bold uppercase text-sm text-grey-dark border-b border-grey-light'
    },
    tableTrStyle(){
      return 'hover:bg-grey-lighter'
    },
    tableTdStyle(){
      return 'py-4 px-6 border-b border-grey-light'
    },
    detailTdDate(){
      return 'pl-4'
    },
    detailTdCount(){
      return 'pl-4 text-right'
    },
    detailTdPrice(){
      return 'pl-4 text-right'
    },
    detailTdAction(){
      return 'pl-4 text-right'
    },
  },
  methods: {
    openHoldingModal: function (event) {
      this.modalHoldingFlag = true
    },
    closeHoldingModal: function(event) {
      this.modalHoldingFlag = false
      this.$apollo.queries.allHoldings.refetch()
    },
    openSellingModal: function(e, holding, aggDetail) {
      this.modalSellingFlag = true
      this.modalSellingHolding = holding
      this.modalSellingDetail = aggDetail
    },
    closeSellingModal: function(){
      this.modalSellingFlag = false
      this.modalSellingHolding = null
      this.modalSellingDetail = null
      this.$apollo.queries.allHoldings.refetch()
    },
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
