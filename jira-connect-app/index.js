const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const ace = require('atlassian-connect-express');
const jwt = require('jsonwebtoken');
const path = require('path');
const winston = require('winston');
const https = require('https');
const fs = require('fs');
require('winston-daily-rotate-file');
require('dotenv').config();



const app = express();
const addon = ace(app);

// Configure winston for logging
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message }) => {
      return `${timestamp} [${level.toUpperCase()}]: ${message}`;
    })
  ),
  transports: [
    new winston.transports.DailyRotateFile({
      filename: 'logs/application-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      maxSize: '20m',
      maxFiles: '14d',
    }),
    new winston.transports.Console({
      format: winston.format.simple(),
    }),
  ],
});

app.use(addon.middleware());

// Middleware to log incoming requests
app.use((req, res, next) => {
  logger.info(`Request Headers: ${JSON.stringify(req.headers)}`);
  logger.info(`Request Body: ${JSON.stringify(req.body)}`);
  logger.info(`Request Query: ${JSON.stringify(req.query)}`);
  next();
});

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use('/aiv', express.static(path.join(__dirname, 'public')));


// Load .pem files
const options = {
  key: fs.readFileSync('${process.env.private}'), // Path to your private key
  cert: fs.readFileSync('${process.env.cert}') // Path to your certificate
};

const jwtStore = new Map();

// Middleware to handle JWT validation and set context for API requests
app.use('/aiv', async (req, res, next) => {
  logger.info(`Requesting URL: ${process.env.aivurl}${req.path}`);

  const isStaticFile = req.path.match(
    /\.(js|css|png|jpg|jpeg|gif|svg|ico|map|json|woff2|ttf)$|\/sso_login$/
  );
  if (isStaticFile) {
    return next();
  }

  const add_token = req.headers.stoken;
  if (add_token) {
    return next();
  }

  const jwtToken = req.headers.authorization?.replace('Bearer ', '') || req.query.jwt;

  if (!jwtToken) {
    logger.error('JWT token missing');
    return res.status(401).send('Unauthorized: JWT token missing');
  }

  try {
    const decoded = jwt.decode(jwtToken, { complete: true });
    const clientKey = decoded?.payload?.iss;

    if (!clientKey) {
      logger.error('Client key missing in JWT payload');
      return res.status(401).send('Unauthorized: Client key missing');
    }

    res.locals.context = {
      clientKey: clientKey,
      jwt: jwtToken,
    };

    logger.info(`JWT and context set: ${JSON.stringify(res.locals.context)}`);
    next();
  } catch (err) {
    logger.error(`JWT validation error: ${err.message}`);
    res.status(401).send('Unauthorized: Invalid JWT token');
  }
});

app.get('/main', addon.authenticate(), async (req, res) => {
  const { clientKey } = res.locals.context;
  try {
    res.render('main', {
      title: 'Your App',
      clientKey: clientKey,
    });
  } catch (error) {
    logger.error(`Error rendering main page: ${error.message}`);
    res.status(500).send('Error loading page');
  }
});

app.post('/installed', async (req, res) => {
  try {
    const { clientKey, baseUrl, productType, sharedSecret, userId } = req.body;

    if (!clientKey || !sharedSecret) {
      return res.status(400).send('Missing clientKey or sharedSecret');
    }

    const department = baseUrl.split('https://')[1].replace(/\./g, '_');

		 axios({
			  method: req.method,
			  url: `${process.env.aivurl}/aiv${req.path}`,
			  headers: {
				...req.headers,
				Host: 'marketplace.aivhub.com',
				dc: `${department}`,
				username: `${userId}`,
				clientKey: `${clientKey}`,
				baseUrl: `${baseUrl}`,
				productType: `${productType}`,
				sharedSecret: `${sharedSecret}`,
			  },
			  data: req.body,
			  responseType: 'stream', // Preserve the exact content type for static files
			  maxRedirects: 0, // Disable automatic redirection handling in Axios
			  validateStatus: (status) => status >= 200 && status < 400,
			})
			  .then((response) => {
				// Set headers before piping the response body
				Object.entries(response.headers).forEach(([key, value]) => {
				  res.setHeader(key, value);
				});

				// Pipe the response body directly to the client
				response.data.pipe(res);
			  })
			  .catch((error) => {
				// Ensure no headers or body are sent before this point
				logger.error(`Error proxying request: ${error.response?.data || error.message}`);

				if (!res.headersSent) { // Check if headers are already sent
				  res
					.status(error.response?.status || 500)
					.send('Proxy error');
				}
			  });
		

    //console.log('Client successfully registered:', clientKey);
    res.status(200).send('Installation successful');
  } catch (error) {
    logger.error(`Installation error: ${error.message}`);
    res.status(500).send('Installation failed');
  }
});


// Installation handler
app.post('/uninstalled', async (req, res) => {
  try {
	  
	  //console.log(`Request Headers: ${JSON.stringify(req.body)}`)
	  
	   const jwtToken = req.headers.authorization?.replace('JWT ', '') || req.query.jwt;
	  
    const { baseUrl, productType, sharedSecret, } = req.body;

	
	// Decode the JWT
		const decodedToken = jwt.decode(jwtToken, { complete: true });
		
		console.log(decodedToken)

		const clientKey = decodedToken.payload.iss;
		const userId = decodedToken.payload.sub;
	
	

    if (!clientKey) {
		console.error('Missing clientKey or sharedSecret');
      return res.status(400).send('Missing clientKey or sharedSecret');
    }
	
	const department = req.body.baseUrl.split("https://")[1].replace(/\./g, "_");
	

		 axios({
			  method: req.method,
			  url: `${process.env.aivurl}/aiv${req.path}`,
			  headers: {
				...req.headers,
				Host: 'marketplace.aivhub.com',
				dc: `${department}`,
				username: `${userId}`,
				clientKey: `${clientKey}`,
			  },
			  data: req.body,
			  responseType: 'stream', // Preserve the exact content type for static files
			  maxRedirects: 0, // Disable automatic redirection handling in Axios
			  validateStatus: (status) => status >= 200 && status < 400,
			})
			  .then((response) => {
				// Set headers before piping the response body
				Object.entries(response.headers).forEach(([key, value]) => {
				  res.setHeader(key, value);
				});

				// Pipe the response body directly to the client
				response.data.pipe(res);
			  })
			  .catch((error) => {
				// Ensure no headers or body are sent before this point
				logger.error(`Error proxying request: ${error.response?.data || error.message}`);

				if (!res.headersSent) { // Check if headers are already sent
				  res
					.status(error.response?.status || 500)
					.send('Proxy error');
				}
			  });
		

    //console.log('Client successfully registered:', clientKey);
    res.status(200).send('Installation successful');
  } catch (error) {
      logger.error(`Installation error: ${error.message}`);
    res.status(500).send('Installation failed');
  }
});


// Proxy requests to Spring Web App
app.use('/aiv',  (req, res) => {
	logger.info(`Proxying request to: ${process.env.aivurl}${req.path}`);

	 const isStaticFile = req.path.match(/\.(js|css|png|jpg|jpeg|gif|svg|ico|map|json|woff2|ttf)$|\/sso_login$/);


  if (isStaticFile) {

      axios({
		method: req.method,
		url: `${process.env.aivurl}/aiv${req.path}`,
		data: req.body,
		responseType: 'stream', // Preserve the exact content type for static files
		maxRedirects: 0, // Disable automatic redirection handling in Axios
		validateStatus: (status) => status >= 200 && status < 400,
	  })
    .then((response) => {
        //delete response.headers['content-security-policy'];
		if (response.status >= 300 && response.status < 400 && response.headers.location) {
			// Forward the redirect to the client
			res.redirect(response.status, response.headers.location);
      } else {
			  // Forward the backend's response headers
			Object.entries(response.headers).forEach(([key, value]) => {
				res.setHeader(key, value);
		  });
	  }

      response.data.pipe(res);
    })
    .catch((error) => {
      logger.error(`Error proxying request: ${error.response?.data || error.message}`);
      res.status(error.response?.status || 500).send('Proxy error');
    });
  } else {
	  
	   const add_token = req.headers.stoken;
  
	  if (add_token) {
				 axios({
						  method: req.method,
						  url: `${process.env.aivurl}/aiv${req.path}`,
						  headers: {
							...req.headers,
							host: 'marketplace.aivhub.com', // Ensure 'host' is lowercase
						  },
						  data: ['POST', 'PUT', 'PATCH'].includes(req.method.toUpperCase()) ? req.body : undefined,
						 responseType: 'stream',
						  maxRedirects: 0, // Disable automatic redirection
						  validateStatus: (status) => status >= 200 && status < 400, // Accept success and redirect statuses
					})
					  .then((response) => {
							// Handle redirects
							if (response.status >= 300 && response.status < 400 && response.headers.location) {
							  res.redirect(response.status, response.headers.location);
							} else {
								  // Forward headers and status to the client
								  Object.entries(response.headers).forEach(([key, value]) => {
										res.setHeader(key, value);
								  });
								  res.status(response.status);

								  if (response.data.pipe) {
									  response.data.pipe(res);
									} else {
									  res.send(response.data);
									}
							}
					  })
					  .catch((error) => {
						logger.error(`Error proxying request: ${error.response?.data || error.message}`);
						res.status(error.response?.status || 500).send('Proxy error');
					  });
	  } else {
		const department = req.context.hostBaseUrl.split("https://")[1].replace(/\./g, "_");
		//console.log('department:', department); 
	  
		const { jwt: jwtToken } = res.locals.context;
  

		// Decode the JWT
		const decodedToken = jwt.decode(jwtToken, { complete: true });

		const clientKey = decodedToken.payload.iss;
		const user = decodedToken.payload.sub;

			axios({
				method: req.method,
				url: `${process.env.aivurl}/aiv${req.path}`,
				headers: { Authorization: `Bearer ${jwtToken}`, dc: `${department}`, username: `${user}`},
				maxRedirects: 0, // Disable automatic redirection handling in Axios
				validateStatus: (status) => status >= 200 && status < 400,
				data: req.body,
			  })
				.then((response) => {
					Object.entries(response.headers).forEach(([key, value]) => {
					res.setHeader(key, value);
				  });
					if (response.status >= 300 && response.status < 400 && response.headers.location) {
					// Forward the redirect to the client
					
					res.redirect(response.status, response.headers.location);
				  } else {
						   res.status(response.status).send(response.data);
				  }
					
			 
				})
				.catch((error) => {
				  logger.error(`Error proxying request: ${error.response?.data || error.message}`);
				});
	  }
  
  }
});



function getBaseUrl(clientKey) {
  return pool.query(
    'SELECT base_url FROM security.ai_jira_client WHERE client_key = $1',
    [clientKey]
  )
  .then(({ rows }) => {
    if (rows.length > 0) {
      return rows[0].base_url;  // Return base_url from the first row
    } else {
      throw new Error('Client not registered');  // Throw an error if no rows found
    }
  })
  .catch((error) => {
    //console.error('Error retrieving base URL:', error.message);  // Log the error
    throw error;  // Rethrow the error
  });
}







// Start the server
const port = addon.config.port();
//app.listen(port, () => {
//  console.log(`App running on port ${port}`);
//});

https.createServer(options, app).listen(port, () => {
  console.log(`App is running on https://localhost:${port}`);
});

