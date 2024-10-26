/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing measurements
type SmartContract struct {
	contractapi.Contract
}

type SensorMeasurement struct {
	DeviceId   string `json:"deviceId"`
	PatientId  string `json:"patientId"`
	Unit	   string `json:unit`
	Value1 	   string `json:"value1"`
	Value2	   string `json:"value2"`
	Value3	   string `json:"value3"`
	Timestamp  string `json:"timestamp"`
}

type File struct {
	Hash   	  string `json:"hash"`
	FileName  string `json:"fileName"`
	FileType  string `json:"fileType"`
	Timestamp string `json:"timestamp"`
}

// QueryResult structure used for handling result of query
type QueryResult struct {
	Key    string `json:"Key"`
	Record *SensorMeasurement
}

type QueryResult2 struct {
	Key    string `json:"Key"`
	Record *File
}

// InitLedger adds a base set of itens to the ledger
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	measurements := []SensorMeasurement{
		SensorMeasurement{DeviceId: "", PatientId: "", Unit: "", Value1: "", Value2: "", Value3: "", Timestamp: ""},
	}

	files := []File{
		File{Hash: "", FileName: "", FileType: "", Timestamp: ""},
	}

	for i, measurement := range measurements {
		measurementAsBytes, _ := json.Marshal(measurement)
		err := ctx.GetStub().PutState("MEASUREMENT"+strconv.Itoa(i), measurementAsBytes)

		if err != nil {
			return fmt.Errorf("Failed to put sensorMeasurement to world state. %s", err.Error())
		}
	}

	for i, file := range files {
		fileAsBytes, _ := json.Marshal(file)
		err := ctx.GetStub().PutState("FILE"+strconv.Itoa(i), fileAsBytes)

		if err != nil {
			return fmt.Errorf("Failed to put file to world state. %s", err.Error())
		}
	}

	return nil
}

//  adds a new sensor measurement to the world state with given details
func (s *SmartContract) CreateSensorMeasurement(ctx contractapi.TransactionContextInterface, measurementNumber string, deviceId string, patientId string, unit string, value1 string, value2 string, value3 string, timestamp string) error {
	measurement := SensorMeasurement{
		DeviceId:   deviceId,
		PatientId:  patientId,
		Unit: unit,
		Value1: value1,
		Value2:  value2,
		Value3: value3,
		Timestamp: timestamp,
	}

	measurementAsBytes, _ := json.Marshal(measurement)

	return ctx.GetStub().PutState(measurementNumber, measurementAsBytes)
}

func (s *SmartContract) CreateFile(ctx contractapi.TransactionContextInterface, fileNumber string, hash string, fileName string, fileType string, timestamp string) error {
	file := File{
		Hash:   hash,
		FileName:  fileName,
		FileType: fileType,
		Timestamp: timestamp,
	}

	fileAsBytes, _ := json.Marshal(file)

	return ctx.GetStub().PutState(fileNumber, fileAsBytes)
}

// returns the sensor measurement stored in the world state with given id
func (s *SmartContract) QuerySensorMeasurement(ctx contractapi.TransactionContextInterface, measurementNumber string) (*SensorMeasurement, error) {
	measurementAsBytes, err := ctx.GetStub().GetState(measurementNumber)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if measurementAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", measurementNumber)
	}

	measurement := new(SensorMeasurement)
	_ = json.Unmarshal(measurementAsBytes, measurement)

	return measurement, nil
}

func (s *SmartContract) QueryFile(ctx contractapi.TransactionContextInterface, fileNumber string) (*File, error) {
	fileAsBytes, err := ctx.GetStub().GetState(fileNumber)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if fileAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", fileNumber)
	}

	file := new(File)
	_ = json.Unmarshal(fileAsBytes, file)

	return file, nil
}

//  returns all sensor measurements found in world state
func (s *SmartContract) QueryAllSensorMeasurements(ctx contractapi.TransactionContextInterface) ([]QueryResult, error) {
	startKey := ""
	endKey := ""

	resultsIterator, err := ctx.GetStub().GetStateByRange(startKey, endKey)

	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []QueryResult{}

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()

		if err != nil {
			return nil, err
		}

		measurement := new(SensorMeasurement)
		_ = json.Unmarshal(queryResponse.Value, measurement)

		queryResult := QueryResult{Key: queryResponse.Key, Record: measurement}
		results = append(results, queryResult)
	}

	return results, nil
}

func (s *SmartContract) QueryAllFiles(ctx contractapi.TransactionContextInterface) ([]QueryResult2, error) {
	startKey := ""
	endKey := ""

	resultsIterator, err := ctx.GetStub().GetStateByRange(startKey, endKey)

	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []QueryResult2{}

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()

		if err != nil {
			return nil, err
		}

		file := new(File)
		_ = json.Unmarshal(queryResponse.Value, file)

		queryResult := QueryResult2{Key: queryResponse.Key, Record: file}
		results = append(results, queryResult)
	}

	return results, nil
}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))

	if err != nil {
		fmt.Printf("Error create smarthealth chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting smarthealth chaincode: %s", err.Error())
	}
}
