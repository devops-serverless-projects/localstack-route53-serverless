module.exports.hello = (event, context, callback) => {
		const response = {
				"statusCode": 200,
				"headers": {},
				"body": 'hello world-us-wesr-1'
		}
		callback(null, response);
};

module.exports.goodbye = (event, context, callback) => {
		const response = {
				"statusCode": 200,
				"headers": {},
				"body": 'goodbye-us-west-1'
		}
		callback(null, response);
};
