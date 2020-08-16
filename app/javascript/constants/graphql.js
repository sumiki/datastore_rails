import gql from 'graphql-tag'

export const ALL_HOLDINGS_QUERY = gql`
  query AllHoldingsQuery($accountId: ID!) {
    allHoldings(accountId: $accountId) {
      name
      tickerSymbol
      totalCount
      holdingCount
      aggregateDetails {
        purchaseDate
        count
        purchasePrice
        price
      }
    }
  }
`
export const CREATE_HOLDING_MUTATION = gql`
  mutation ($accountId: Int!, $tickerSymbol: String!, $name: String!, $purchaseCount: Int!, $purchasePrice: Float!, $purchaseDate: String!){
    createHolding(input: { accountId: $accountId, name: $name, tickerSymbol: $tickerSymbol, purchaseCount: $purchaseCount, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate }) {
      holding {
        name
        tickerSymbol
      }
      errors
    }
  }
`

export const SELLING_HOLDING_MUTATION = gql`
  mutation ($accountId: Int!, $tickerSymbol: String!, $purchasePrice: Float!, $purchaseDate: String!, $sellingCount: Int!, $sellingPrice: Float!, $sellingDate: String!, ){
    sellingHolding(input: { accountId: $accountId, tickerSymbol: $tickerSymbol, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate, sellingCount: $sellingCount, sellingPrice: $sellingPrice, sellingDate: $sellingDate }) {
      holding {
        name
        tickerSymbol
      }
      errors
    }
  }
`
