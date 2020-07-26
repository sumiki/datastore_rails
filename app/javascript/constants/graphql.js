import gql from 'graphql-tag'

export const ALL_HOLDINGS_QUERY = gql`
  query AllHoldingsQuery($accountId: ID!) {
    allHoldings(accountId: $accountId) {
      name
    }
  }
`
