import gql from 'graphql-tag'

export const ALL_HOLDINGS_QUERY = gql`
  query AllHoldingsQuery($accountId: ID!) {
    allHoldings(accountId: $accountId) {
      name
      tickerSymbol
      aggregateDetails {
        purchaseDate
        count
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
