const AWS = require('aws-sdk');
const S3 = new AWS.S3({region: 'us-east-1', endpoint: new AWS.Endpoint('http://host.docker.internal:4566'), s3ForcePathStyle: true});
const SQS = new AWS.SQS({region: 'us-east-1', endpoint: new AWS.Endpoint('http://host.docker.internal:4566')});

exports.handler = async (event) => {
  console.info("EVENT\n" + JSON.stringify(event, null, 2))
  event.Records.forEach(record => {
    console.info("Record: " + record.body);
  });
  return event.Records;
}

exports.s3reader = async (event) => {
  console.info("TEST");
  const data = await S3.getObject({Bucket: 'test-bucket', Key: 'testdata.json'}).promise();
  const file = data.Body.toString('utf-8');
  console.log(file);
  const obj = JSON.parse(file);

  obj.rows.forEach(async (row) => {
    console.log("Row with ID: " + row.id);
    var params = {
      MessageBody: row.id,
      QueueUrl: "http://host.docker.internal:4566/000000000000/test-queue.fifo",
      MessageGroupId: "123"
    }
    const sqsResponse = await SQS.sendMessage(params).promise();
    console.log(sqsResponse);
  });
  return {
    statusCode: 200,
    body: obj
  }
}
