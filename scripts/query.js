const axios = require('axios')


async function main() {
    
    const url = 'https://gateway.thegraph.com/api/31ebc3478a4f121f7d5d0dc2f8addd2c/subgraphs/id/84CvqQHYhydZzr2KSth8s1AFYpBRzUbVJXq6PWuZm9U9'
    
    const headers = {
        'content-type': 'application/json'
    }

    const query = {
        query: `query {
                accounts(
                first: 100, 
                skip: 10000, 
                orderBy: borrowCount,
                    orderDirection: desc,
                    where: {borrowCount_gt: 0}) {
                id
                deposits {
                    id
                    asset {
                        symbol
                    }
                    amount
                }
                borrows {
                    id
                    asset {
                    symbol
                    }
                    amount
                }
                }
          }`
    }
    
    
    const response = await axios({
        url: url,
        method: 'post',
        headers: headers,
        data: query
    })
    
    console.log(response.data.data.accounts)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });