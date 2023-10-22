import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { BrowserRouter } from "react-router-dom";

import { WalletProvider } from '@suiet/wallet-kit';
import '@suiet/wallet-kit/style.css';


ReactDOM.render(
  <WalletProvider>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </WalletProvider>,
  document.getElementById('root')
);

