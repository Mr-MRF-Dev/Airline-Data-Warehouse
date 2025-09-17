# ✈ Airline Data Warehouse

![GitHub repo size](https://img.shields.io/github/repo-size/Mr-MRF-Dev/Airline-Data-Warehouse)
[![GitHub License](https://img.shields.io/github/license/Mr-MRF-Dev/Airline-Data-Warehouse)](/LICENSE)

The Airline Data Warehouse (DWH) project is designed to consolidate, store, and analyze airline-related data efficiently. The goal is to provide a robust platform for data integration, reporting, and business intelligence, supporting better decision-making in the airline industry.

This project is a collaborative effort developed as part of the **Database II course**. Our team has designed and implemented a comprehensive data warehouse solution specifically for the airline industry.

## 🚧 Project Status: Developer Mode

This project is currently in **developer mode**. Please note:

- Some code and configuration files may contain bugs or errors.
- Code optimization and refactoring are ongoing.
- Features and documentation are subject to change.
- Use at your own risk; not recommended for production environments.

We appreciate your understanding as we continue to improve and stabilize the project.

## 🐳 Using Docker

You can also run Airline-Data-Warehouse using Docker, which provides a consistent environment across different systems.

### Prerequisites

Make sure you have [Docker](https://www.docker.com/) installed on your system.

### Running with Docker

1. Clone the repository (if you haven't already):

   ```bash
   git clone https://github.com/Mr-MRF-Dev/Airline-Data-Warehouse.git
   ```

    navigate to the project directory:

   ```bash
   cd Airline-Data-Warehouse
   ```

2. Build the Docker image:

   ```bash
   docker build -t airline-data-warehouse .
   ```

3. Run the container:

   ```bash
   docker run -p 1433:1433 airline-data-warehouse
   ```

4. using [sql server management studio](https://learn.microsoft.com/en-us/ssms/) connect to the database using the following credentials:

   - Server Type: `Database Engine`
   - Server Name: `localhost,1433`
   - Authentication: `SQL Server Authentication`
   - Username: `sa`
   - Password: `Admin@Pass`

   or using [sql cmd](https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16):

   ```bash
    sqlcmd -S localhost,1433 -U sa -P Admin@Pass
    ```

## 👥 Team Members

The project is a collaborative effort by the following team members:

- [Alipour8](https://github.com/Alipour8)
- [Mohammad Kazemi](https://github.com/mohammadkazemy)
- [Mr MRF Dev](https://github.com/Mr-MRF-Dev)

## 🤝 Contributing

we welcome any contributions you may have. If you're interested in helping out, fork the repository
and create an [Issue](https://github.com/Mr-MRF-Dev/Airline-Data-Warehouse/issues) and
[PR](https://github.com/Mr-MRF-Dev/Airline-Data-Warehouse/pulls).

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.
