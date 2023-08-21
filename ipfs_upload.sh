# Replace with the path to your IPFS log file
LOGFILE="PATH_TO_YOUR_LOG_FILE"

# Replace with the IP address and port of your IPFS node
IPFS_API_ADDRESS="IP_ADDRESS_OF_YOUR_IPFS_NODE"
IPFS_API_PORT="PORT_OF_YOUR_IPFS_NODE"

# Time for some IPFS magic! 🎩✨
for f in "$@"
do
  # Uploading your precious files to the intergalactic web! 🚀
  RESULT=$(/opt/homebrew/bin/ipfs --api /ip4/$IPFS_API_ADDRESS/tcp/$IPFS_API_PORT add -r -w --cid-version 1 "$f" 2>/dev/null)
  if [ $? -eq 0 ]; then
    CID=$(echo "$RESULT" | tail -n 1 | awk '{print $2}')
    echo "$CID,$f" >> "$LOGFILE"
    
    # Pinning the file, so it doesn't float away into the cosmos! 📌🌌
    /opt/homebrew/bin/ipfs --api /ip4/$IPFS_API_ADDRESS/tcp/$IPFS_API_PORT pin add "$CID"
    
    # Copying the CID to the clipboard – as easy as Ctrl-C, Ctrl-V! 📋✂️
    echo -n "$CID" | pbcopy
    osascript -e "display notification \"Successfully processed $f. CID: $CID\" with title \"IPFS Upload\""
  else
    # Oops! Something went wrong. Don't worry; the log file will tell us what happened. 🕵️‍♂️🔍
    echo "Error processing $f: $RESULT" >> "$LOGFILE"
    osascript -e "display notification \"Error processing $f: $RESULT\" with title \"IPFS Upload\""
  fi
done

# And that's it! Your files are now part of the decentralized web. 🎉🌐
