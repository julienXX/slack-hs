{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Environment
import Data.List
import Data.Text as T hiding (head)
import Data.Text.Encoding
import qualified Data.ByteString.Lazy.Char8 as BS (putStrLn)
import Control.Lens
import Data.Aeson.Lens
import Network.Wreq

apiUrl :: String
apiUrl = "https://slack.com/api/"

type Token = Text
type Channel = Text
type Message = Text

main :: IO ()
main = do
  token <- getEnv "SLACK_TOKEN"
  args <- getArgs
  -- postMessage "@julienxx" (pack $ head args) (pack token)
  listChannels $ pack token

listChannels :: Token -> IO()
listChannels token = do
  let requestUrl = apiUrl ++ "channels.list"
  r <- post requestUrl ["token" := token]
  BS.putStrLn $ r ^. responseBody

postMessage :: Channel -> Message -> Token -> IO()
postMessage channel message token = do
  let requestUrl = apiUrl ++ "chat.postMessage"
  r <- post requestUrl ["token" := token, "channel" := channel, "text" := message, "as_user" := pack "true"]
  BS.putStrLn $ r ^. responseBody
