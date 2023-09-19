const Calculator = artifacts.require('Calculator');

contract('Calculator', () => {
	it('should add data correctly', async () => {
		const calculatorInstance = await Calculator.deployed();
		addition_result = await calculatorInstance.add(2,2);
		assert(addition_result.toString() === '4');
	});

	it('should subtract data correctly', async () => {
		const calculatorInstance = await Calculator.deployed();
		addition_result = await calculatorInstance.subtract(4,2);
		assert(addition_result.toString() === '2');
	});

	it('should multiply data correctly', async () => {
		const calculatorInstance = await Calculator.deployed();
		addition_result = await calculatorInstance.multiply(4,2);
		assert(addition_result.toString() === '8');
	});

	it('should divide data correctly', async () => {
		const calculatorInstance = await Calculator.deployed();
		addition_result = await calculatorInstance.divide(4,2);
		assert(addition_result.toString() === '2');
	});

	it('should RETURN data correctly', async () => {
		const calculatorInstance = await Calculator.deployed();
		addition_result = await calculatorInstance.jsonData();
		assert(addition_result.toString() === 'Sample');
	});
});
