import numpy as np
import matplotlib.pyplot as plt

## Function that takes a random seed and (symmetric) domain and return:
#### Coefficients 
#### Coefficients fitted on noisy data 
#### Noisy data
## Prints a report and makes a plot if specified. 

def noisy_even_polynomial_analysis(rand_seed, sym_domain, print_statements=False, plots=False):
	
	## Original coefficients 
	np.random.seed(rand_seed)
	coeff_range = 10
	ncoeff = 8
	# Random (even) coefficients in the range [-10, 10], decreasing power
	coefficients = np.random.uniform(-1.*coeff_range, 1.*coeff_range, ncoeff)  
	# No constant or odd coefficients 
	for i in range(ncoeff):
		order = ncoeff - i - 1
		if order % 2 != 0 or order == 0:
			coefficients[i] = 0
			
	## Define the ncoeff-1-th-order polynomial function
	polynomial = np.poly1d(coefficients)
	
	## Generate x values
	npoints = 500
	x = np.linspace(-1.*sym_domain, 1.*sym_domain, npoints)

	## Normalize/update the polynomial (coefficients)
	norm_factor = polynomial(sym_domain)
	coefficients /= norm_factor
	polynomial = np.poly1d(coefficients)

	## Generate y values using the polynomial and add random noise
	noise_std = 0.9  # Standard deviation of the noise
	y = polynomial(x)
	y_noisy = y + np.random.normal(0, noise_std, x.shape)

	## Fit the noisy data to a ncoeff-1-th-order polynomial
	fitted_coefficients = np.polyfit(x, y_noisy, ncoeff-1)
	fitted_polynomial = np.poly1d(fitted_coefficients)
	y_fitted = fitted_polynomial(x)
	
	## Print statements if specificied 
	if print_statements:
		print('Original polynomial : ')
		print(polynomial)
		print(polynomial(sym_domain))
		print('min/max original polynomial : ')
		print(np.min(y), np.max(y))
		print('\n')
		print('min/max noisy data : ')
		print(np.min(y_noisy), np.max(y_noisy))
		print('\n')
		print('Fitted polynomial : ')
		print(fitted_polynomial)
		print('min/max fitted polynomial : ')
		print(np.min(y_fitted), np.max(y_fitted))
	
	## Plot results if specified 
	if plots:
		plt.figure(figsize=(10, 6))
		plt.plot(x, y, label="True polynomial", color="red", linewidth=2)
		plt.scatter(x, y_noisy, label="Noisy data", color="blue", s=10, alpha=0.7)
		plt.plot(x, y_fitted, label="Fitted polynomial", color="green", linewidth=2, linestyle='--')
		plt.xlabel("x")
		plt.ylabel("y")
		plt.title(f"Noisy Data Around a {ncoeff-1}th-Order Polynomial")
		plt.legend()
		plt.show()
		
	return coefficients, fitted_coefficients, y_noisy




