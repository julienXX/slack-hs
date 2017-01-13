{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Environment
import Data.List
import Network.HTTP.Simple
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.ByteString.Char8 as S8

apiUrl :: String
apiUrl = "https://slack.com/api/"

type Token = String
type Channel = String
type Message = String

main :: IO ()
main = do
  args <- getArgs
  token <- getEnv "SLACK_TOKEN"
  -- postMessage (head args) token
  listChannels token

listChannels :: Token -> IO()
listChannels token = do
  request' <- parseRequest ("POST " ++ apiUrl ++ "channels.list")
  let request = setRequestQueryString [("token", Just (S8.pack token))]
                $ request'
  response <- httpLBS request

  L8.putStrLn $ getResponseBody response

postMessage :: Channel -> Message -> Token -> IO()
postMessage channel message token = do
  request' <- parseRequest ("POST " ++ apiUrl ++ "chat.postMessage")
  let request = setRequestQueryString [("token", Just (S8.pack token)),
                                       ("channel", Just (S8.pack channel)),
                                       ("text", Just (S8.pack message))]
                $ request'
  response <- httpLBS request

  L8.putStrLn $ getResponseBody response
