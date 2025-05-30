package main

import (
    "database/sql"
    "log"
    "net/http"

    "github.com/gin-gonic/gin"
    _ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

func main() {
    var err error

    // Connect to MySQL database
    dsn := "username:password@tcp(127.0.0.1:3306)/hospital_db"
    db, err = sql.Open("mysql", dsn)
    if err != nil {
        log.Fatal("Failed to open database: ", err)
    }

    // Ping DB to confirm connection
    if err = db.Ping(); err != nil {
        log.Fatal("Failed to connect to database: ", err)
    }

    router := gin.Default()

    // Sample endpoint to generate report
    router.POST("/generate-report/:patient_id", generateReportHandler)

    log.Println("Server started on http://localhost:8080")
    router.Run(":8080")
}

// generateReportHandler calls a stored procedure when treatment is added
func generateReportHandler(c *gin.Context) {
    patientID := c.Param("patient_id")

    // Call your stored procedure
    _, err := db.Exec("CALL generate_patient_report(?)", patientID)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "message": "Report generated successfully for patient ID " + patientID,
    })
}
