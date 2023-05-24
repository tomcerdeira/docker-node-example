const request = require('supertest');
const app = require('./index.js');
const chai = require('chai');
const expect = chai.expect;

describe('GET /', () => {
  it('should return "Hello World from Docker and Node.js!"', async () => {
    const response = await request(app).get('/');
    expect(response.status).to.equal(200);
    expect(response.text).to.include('<h1>Hello World from Docker and Node.js!</h1>');
    // expect(response.text).to.include('This should fail Jenkins build! ');
  });
});
