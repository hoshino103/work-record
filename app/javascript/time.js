const time = () => {
  const set2 = (num) => {
    let ret;
    if (num < 10 ) { ret = "0" + num; }
    else { ret = num; }
    return ret;
  }
  const showClock = () => {
    const time = new Date();
    const hour = set2(time.getHours());
    const min = set2(time.getMinutes());
    const sec = set2(time.getSeconds());
    const year = time.getFullYear();
    const month = (time.getMonth()+1);
    const day = time.getDate();
    const toDay = year + "-" + month + "-" + day;
    const beginDay = document.getElementById("begin-day");
    beginDay.value = toDay;
    const finishDay = document.getElementById("finish-day");
    finishDay.value = toDay;

    const clock = hour + ":" + min + ":" + sec;
    document.getElementById("clock").innerHTML = clock;
    const begin = document.getElementById("begin");
    begin.value = clock;
    const finish = document.getElementById("finish");
    finish.value = clock;
  }
  setInterval(showClock, 1000);
};

window.addEventListener("load",time)