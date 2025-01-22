# Northern Health Hospital Custom MPage Boilerplate

This project is a boilerplate for creating a custom MPage in Cerner PowerChart using Bootstrap and Vite. It is designed to streamline the development process for Northern Health Hospital.

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

After building the project, the static files will be created in the `dist` directory. These files should be copied to the `custom_mpage_content/custom-mpage` directory in the `M://` drive.


## Configuration

Ensure the following settings are configured in `prefmaint.exe`:

```
REPORT_NAME: <url>$DM_INFO:CONTENT_SERVICE_URL$/custom_mpage_content/custom-mpage/index.html?m=^CHT^&pId=$PAT_PERSONID$&eId=$VIS_ENCNTRID$&uId=$USR_PERSONID$&pCd=$USR_PositionCd$&ppr=$PAT_PPRCode$&app=^$APP_AppName$^
WEB_BROWSER_SELECTION: 1-Edge Chromium
```

## License

This project is licensed under the MIT License.

## Contact

For more information, please contact the project maintainers at [email@example.com](mailto:email@example.com).
