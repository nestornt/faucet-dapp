import { useEffect, useState, useCallback } from "react"
import Web3 from "web3";
import "./app.css";
import detectEthereumProvider from "@metamask/detect-provider"
import { loadContract } from "./utils/load-contract"

function App() {

  const [ web3Api, setWeb3Api ] = useState({
    provider: null,
    isProviderLoaded: false,
    web3: null,
    contract: null
  })

  const [ balance, setBalance ] = useState(null)
  const [ account, setAccount ] = useState(null)
  const [ shouldReload, reload ] = useState(false)
 
  const canConnectToContract = account && web3Api.contract

  // We have to memorize reloadUI to allow it too on addsFunds function
  const reloadUI = useCallback(() => 
    reload(!shouldReload), [shouldReload]
  )

  // Change the state if we change account or network (See metamask documentation "ethereum.on" fn)
  const setAccountListener = provider => {
    provider.on("accountsChanged", () => window.location.reload())
    provider.on("chainChanged", () => window.location.reload())

  }

  // Sets up the provider and contract data on first load
  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider()
 
      if (provider) {
        const contract  = await loadContract("Faucet", provider)
        setAccountListener(provider)

        setWeb3Api({
          web3: new Web3(provider),
          provider,
          contract,
          isProviderLoaded: true
        })
      } else {
        // If we dont have any provider we have to load it as well
        // functional update, it recieves the current state of web3api as callback parameter
        setWeb3Api( (api) => ({ ...api, isProviderLoaded: true }))
        console.log("Please, install Metamask")
      }
    }

    loadProvider()
  }, [])

  // Sets up the contract balance in ether
  useEffect(() => {
    const loadBalance = async () => {
      const { contract, web3 } = web3Api
      const balance = await web3.eth.getBalance( contract.address )
      const ethBalance = web3.utils.fromWei( balance, "ether" )
      setBalance( ethBalance )
    }
    web3Api.contract && loadBalance()
    
  }, [web3Api, shouldReload])

  // Get our current metamask account address
  useEffect(() => {
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts()

      setAccount(accounts[0])
    }

    web3Api.web3 && getAccount()
  }, [web3Api.web3])

  // UseCallback memorizes the callback function (first param) 
  // and its not created again everytime its re-rendered
  const addFunds = useCallback(async () => {
    const { contract, web3 } = web3Api
    await contract.addFunds({
      from: account,
      value: web3.utils.toWei( "1", "ether" )
    })

    reloadUI()

  }, [web3Api, account, reloadUI])

  const withdrawFunds = async () => {
    const { contract, web3 } = web3Api
    const withdrawAmount = web3.utils.toWei( "0.1", "ether" )
    await contract.withdraw(withdrawAmount,{
      from: account,
    })
    reloadUI()
  }

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet card">
          { web3Api.isProviderLoaded ?
            <div className="is-flex is-align-items-center">
              <span>
                <strong className="mr-2">Account:  </strong>
              </span>
              { account ? 
                <span>{ account }</span> : 
                !web3Api.provider ?
                <>
                  <div className="notification is-warning is-size-6 is-rounded">
                    Wallet not detected!{` `}
                    <a target="_blank" rel="noopener noreferrer" href="https://docs.metamask.io">
                      Install Metamask
                    </a>
                  </div>
                </> :
                <button 
                  className="button is-small ml-3"
                  onClick={() => 
                    web3Api.provider.request({ method: "eth_requestAccounts"})
                  }
                >
                  Connect Wallet
                </button>
              }
            </div> :
            <span>Looking for Web3..</span>
          }
 
          <div className="balance-view is-size-2 my-4">
            current Balance: <strong>{ balance }</strong> ETH
          </div>
          { !canConnectToContract && 
            <i className="is-block">
              Connect to Ganache
            </i>
          }
          <button 
            className="button is-info mr-2"
            onClick={ addFunds }
            disabled={ !canConnectToContract }
          >
            Donate 1 eth
          </button>
          <button
            className="button is-primary"
            onClick={ withdrawFunds }
            disabled={ !canConnectToContract }
          >
            Withdraw 0.1 eth
          </button>
        </div>
      </div>
    </>
  );
}

export default App;

/* 

  will reload the browser
  window.location.reload();

  Change the state if we change account (See metamask documentation "ethereum.on" fn)
  const setAccountListener = provider => {
    provider.on("accountsChanged", accounts => setAccount(accounts[0]))

    Refresh the account state whenever we disconnect our wallet
    /*provider._jsonRpcConnection.events.on("notification", payload => {
      const { method } = payload

      if (method === "metamask_unlockStateChanged") {
        setAccount(null)
      }
    })
  }
    
*/
