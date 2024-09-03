#!/bin/bash

(export $(grep -v '^#' .env | xargs) && iex -S mix run)
