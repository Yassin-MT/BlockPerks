# Block Perks
Distributing vouchers, for employees, which are valid at participating merchants. 

## Summary
Companies use vouchers  to motivate their employees to access services, or buy goods provided by Registered Service Providers, called merchants. Vouchers are issued in the name of the applicant company (the Recipient), have no cash value and are non-transferable; they are only payable to the selected Registered Service provider. The company them sends/provides the issued vouchers to its emplployees; the company can send these vouchers to all emplpyees, specific list of employees or employees based on their role/job category (e.g., sales personel).

The amount of vouchers, that are issued, are always backed by a stable equivalent value of crypto in order to offer transparency and guarantee the value of the vouchers. Indeed, when vouchers are  issued for a company, they  are paid by the company using a stable coin. The corresponding amount of the coin will be locked;  it will be later on handed over to the merchant as exchange of the vouchers redeemed by the employees. A percentage of the amount will be paid as fees to the voucher provider. This amount can be a fixed percentage or any sophisticated fees computation scheme that can be implemented using a smart contract. For the current implementation we used a fixed percentage of the voucher value as fees to be charged by the voucher provider.

## Actors
### Voucher Provider
Negotiates with merchants to accept vouchers. It will sell vouchers for these merchants; thus, the voucher provider will have a list of merchants that signed an agreement. 

- Voucher will have the following information: Amount, Company for which the voucher is minted, expiration date, merchant, and policy (here we can code few policies that are concerned with what to do upon expiration: (1) send back $$ to the company after fees; (2) leave the token but reduce its value using a formula (e.g., x% less per month or something like that) ; etc. In this version, we implemented policy 1

### Company
Company that is interested in getting vouchers, needs to register with the voucher provider by sending the transaction register to the voucher provider smart contract.

Voucher provider will provide a UI to a company to:
1.	Register/unregister 
2.	Dash board :  Vouchers distributed, amount, expiration date, expired vouchers, etc.
3.	Record employees and employees categories with the voucher provider
4.	Search merchants
5.	 Buy vouchers:  it can include categories (electronic, travel, …); the company selects a category and then a list of merchants are displayed. The company can select a merchant for which it wants to buy vouchers

- For a voucher, it needs to select an amount, and to whom send the voucher; there are 2 options: (1) buy vouchers and assign them to the company address for distribution to employees later; or (2) buy vouchers and immediately provide employees’ addresses to whom to send the voucher (distribution directly by the voucher provider)

- If vouchers to be sent directly to employees, the company, (in the UI) needs to provide the addresses of the employees. 
- Here, for added security, companies can register the addresses of their employees in the smart contract. Thus, the coupon provider verifies that the employee address is valid before sending the coupon.

- The company can also provide a category of employees (e.g., managers), and the voucher provider will send to the employees directly; in this case, we assume that the company registered the employees categories together with the addresses of the corresponding employees.

Several policies can be implemented to process expired vouchers; (1) the corresponding amount is transferred to the company; (2) periodic transfer (e.g., daily and weekly); (3) upon request by the company; etc.

### Employee
A user interface that allows
1.	Get notified when a voucher is received
2.	Use the voucher in a merchant site; from his smart phone, scan the merchant address, and make payment to the merchant
3.	Dashboard/Answer queries: my vouchers, expiration date, remaining amount (we assume that an employee can redeem a portion of the voucher value at a time)
4.	Optionally,   we can allow the employee to send the vouchers to somebody else! It can be an option to provide to the company when buying/creating vouchers. In the current version, vouchers can be only redeemed by corresponding merchants

### Merchant
A user interface that allows
1.	Register with the voucher provider
2.	Be notified when a voucher is consumed (after an employee uses his vouchers) for confirmation.

Several policies can be implemented to process redemption of vouchers; (1) the corresponding amount is transferred to the merchant; (2) periodic transfer (e.g., daily and weekly); (3) upon request by the merchant; etc.
