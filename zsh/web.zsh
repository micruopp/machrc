# List SSH remote hosts
list-remotes() {
  match="Host "
  cat ~/.ssh/config | grep $match | sed 's/'"$match"'//'
}

list-remotes-with-ip() {
  cat ~/.ssh/config | grep "Host" | sed 's/Host.* //'
}


scandns() {
  dig -t A +noall +ans $1
  dig -t AAAA +noall +ans $1
  dig -t CNAME +noall +ans $1
  dig -t MX +noall +ans $1
  dig -t TXT +noall +ans $1
  dig -t NS +noall +ans $1
  dig -t SRV +noall +ans $1
  dig -t CAA +noall +ans $1
}
