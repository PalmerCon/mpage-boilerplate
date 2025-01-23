# Custom MPage Boilerplate

This project is a boilerplate for creating a custom MPage in Cerner PowerChart using Bootstrap and Vite. 

## Getting Started

### Prerequisites

- Node.js
- npm (Node Package Manager)

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/PalmerCon/mpage-boilerplate.git
    ```
2. Navigate to the project directory:
    ```sh
    cd nh-custom-mpage
    ```
3. Install the dependencies:
    ```sh
    npm install
    ```

### Development

To start the development server, run:
```sh
npm run dev
```

### Building for Production

To build the project for production, run:
```sh
npm run build
```

After building the project, the static files will be created in the `dist` directory. These files should be copied to the `custom_mpage_content/custom-mpage` directory in the `M://` drive. If you are developing on your local machine, zip the whole `dist` directory, email it to your work email address, download it on your work computer, and copy the files to the `M://` drive. Refresh the static content server in PowerChart to see the changes.

This boilerplate calls a CCL script that you will need to create called `ahs_cust_mpage_boilerplate`. Copy this file into your Cerner environment and compile it.

## Configuration

Ensure the following settings are configured in `prefmaint.exe`:

```
REPORT_NAME: <url>$DM_INFO:CONTENT_SERVICE_URL$/custom_mpage_content/custom-mpage/index.html?m=^CHT^&pId=$PAT_PERSONID$&eId=$VIS_ENCNTRID$&uId=$USR_PERSONID$&pCd=$USR_PositionCd$&ppr=$PAT_PPRCode$&app=^$APP_AppName$^
WEB_BROWSER_SELECTION: 1-Edge Chromium
```

## License

This project is licensed under the MIT License.

## Contact

For more information, please contact Connor at [connor.palmer@austin.org.au](mailto:connor.palmer@austin.org.au).
