// Import our custom CSS
import '../scss/styles.scss'

// Import all of Bootstrap's JS
import * as bootstrap from 'bootstrap'


async function getPatientDetails(personId) {
    console.log('getting patient details for personId:', personId);
    return new Promise((resolve, reject) => {
      try {
        const xcr = new XMLCclRequest();
        xcr.onreadystatechange = function () {
          if (xcr.readyState === 4 && xcr.status === 200) {
            const data = JSON.parse(xcr.responseText);
            console.log(data);
            resolve(data);
          } else if (xcr.readyState === 4) {
            reject(new Error(xcr.statusText));
          }
        };
        xcr.open('GET', 'ahs_cust_mpage_boilerplate', true);
        xcr.send(`^MINE^,${personId}`);
      } catch (e) {
        setTimeout(() => {
            resolve({
                DATA: {
                    NAME: 'John Doe',
                    AGE: '30',
                }
            });
        }, 1000);
      }
    });
  }


async function getPatientDetailsAndInsertIntoDom() {
    const urlParams = new URLSearchParams(window.location.search);
    const personId = urlParams.get('uId');
    console.log('personId:', personId);
    console.log('getting patient details for personId:', personId);
    document.getElementById('data').innerText = 'Loading...';
    try {
        const patientDetails = await getPatientDetails(personId);
        console.log('patientDetails:', patientDetails);
        document.getElementById('data').innerText = JSON.stringify(patientDetails, null, 2);
    } catch (e) {
        console.error(e);
        document.getElementById('data').innerText = 'Error loading patient details';
    }
}

document.addEventListener('DOMContentLoaded', async () => {
    console.log('DOM loaded');
    await getPatientDetailsAndInsertIntoDom();
});

window.getPatientDetailsAndInsertIntoDom = getPatientDetailsAndInsertIntoDom;