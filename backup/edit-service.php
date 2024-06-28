<?php
include "connect_database.php";
include "encodeDecode.php";
$key = "TheGreatestNumberIs73";
include "src/get_data_from_database/get_services.php";

session_start();
date_default_timezone_set('Asia/Manila');

// Initialize variables with default values
// $ID = $adminID = $serviceID = $serviceName = $serviceCapacity = $serviceRate = $serviceImage = "";

    if (isset($_SESSION["userSuperAdminID"])) {
        $superAdminID = $_SESSION["userSuperAdminID"];
      
        $ID = isset($_GET['value']) ? $_GET['value'] : ' ';
        
        foreach($arrayServices as $service){
            $serviceID = $ID;
	if($service['serviceID'] == $serviceID){
            $serviceName = $service['serviceName'];
            $serviceCapacity = $service['serviceCapacity'];
            $serviceRate = $service['serviceRate'];
        }}
?>
    <!DOCTYPE html>
    <!-- Created by CodingLab |www.youtube.com/CodingLabYT-->
    <html lang="en" dir="ltr">

    <head>
        <meta charset="UTF-8" />
        <title>Services</title>
        <!-- Boxicons CDN Link -->
        <link href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" rel="stylesheet" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Online Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Akronim&family=Anton&family=Aoboshi+One&family=Audiowide&family=Black+Han+Sans&family=Braah+One&family=Bungee+Outline&family=Hammersmith+One&family=Krona+One&family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />

        <!-- Datatables -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" />

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>

        <!-- Bootstrap JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

        <!-- Datatables JS -->
        <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>

        <!-- External CSS -->
        <link rel="stylesheet" href="src/css/sidebar.css" />
        <link rel="stylesheet" href="src/css/style.css" />

        <link rel="icon" href="src/images/Bevitore-logo.png" type="image/x-icon">
    </head>

    <body>

        <?php include "superadmin_sidebar.php"; ?>

        <section class="home-section">
            <h4 class="qreserve mt-5">Edit Service</h4>
            <hr class="my-4">
            <div class="container-fluid" id="profmanage-add-new-profile">
                <form class="row dashboard-square-kebab needs-validation" id="edit-service-form" novalidate>
                    <input type="hidden" name="editID" id="editID" value="<?php echo $ID; ?>">
                    <div class="col-md-12 mb-2">
                        <label for="editServiceName" class="form-label">Service Name <span>*</span></label>
                        <input type="text" value="<?php echo $serviceName; ?>" class="form-control" id="editServiceName" name="editServiceName" placeholder="Enter first name here" required onblur="handleInput(event)" oninput="validateName(event)">
                        <div class="valid-feedback"><!-- Looks good! --></div>
                        <div class="invalid-feedback">Please provide a valid service name.</div>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="editServiceRate" class="form-label">Rate <span>*</span></label>
                        <input type="text" value="<?php echo $serviceRate; ?>" class="form-control" id="editServiceRate" name="editServiceRate" placeholder="Enter rate here" required onblur="handleRateInput(event)" oninput="validateRate(event)" maxlength="5">
                        <div class="valid-feedback"><!-- Looks good! --></div>
                        <div class="invalid-feedback">Please provide a valid rate.</div>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="editCapacity" class="form-label">Capacity <span>*</span></label>
                        <input type="text" value="<?php echo $serviceCapacity; ?>" class="form-control" id="editCapacity" placeholder="Enter capacity here" name="editCapacity" maxlength="3" required onblur="handleCapacityInput(event)" oninput="validateCapacity(event)">
                        <div class="valid-feedback"><!-- Looks good! --></div>
                        <div class="invalid-feedback">Please provide a valid capacity.</div>
                    </div>
                    <div class="col-md-10 mb-2">
                        <label for="editImage" class="form-label">Image <span>*</span></label>
                        <input type="file" value="<?php echo $serviceName; ?>" class="form-control" id="editImage" name="editImage" accept=".jpeg, .jpg, .png" required onchange="validateImage(event)">
                        <div class="valid-feedback"><!-- Looks good! --></div>
                        <div class="invalid-feedback">Please provide a valid file.</div>
                    </div>
                    <div class="col-md-2 mb-2">
                        <img id="imagePreview" src="#" alt="Image Preview">
                    </div>
                    <div class="row justify-content-end mt-5">
                        <div class="col-12 col-md-2 mb-2 mb-md-0">
                            <button class="btn btn-primary w-100 create-button" type="submit" id="create-member-button">Create</button>
                        </div>
                        <div class="col-12 col-md-2 mb-2 mb-md-0">
                            <button class="btn btn-outline-primary w-100 cancel-button" type="button" onclick="window.location.href='service_management.php'">Cancel</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>


        <!-- Add this div at the end of your HTML body to contain the modal -->
        <div class="modal fade" id="confirmAddWalkin" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" aria-labelledby="successModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" id="add-new-service-modal">
                <div class="modal-content text-center">
                    <div class="modal-header">
                        <h2 class="modal-title fw-bold text-center" id="wait"><img src="src/images/icons/hourglass.gif" alt="Wait Icon" class="modal-icons">Wait!</h2>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to edit this service?
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <button type="button" class="btn btn-outline-primary cancel-button" data-bs-dismiss="modal">Edit</button>
                        <button type="button" class="btn btn-primary create-button" data-bs-toggle="modal" data-bs-target="#success-add-walkin-modal">Confirm</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Success Add New Walkin Modal -->
        <div class="modal fade" id="success-add-walkin-modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center" id="wait">
                    <div class="modal-header">
                        <h2 class="modal-title  fw-bold text-center" id="success"><img src="src/images/icons/available-worldwide.gif" alt="Wait Icon" class="modal-icons">Success!</h2>
                    </div>
                    <div class="modal-body text-center">
                        You have successfully edited this service.
                    </div>
                    <div class="modal-footer">
                        <!-- <button class="btn btn-primary create-button" id="proceed" data-bs-target="#" data-bs-toggle="modal">Proceed</button> -->
                        <button class="btn btn-primary  create-button" name="submitWalkin" id="submitWalkin" type="submit">Proceed</button>
                    </div>
                </div>
            </div>
        </div>



        <script src="src/js/edit_services.js"></script>
        <script src="src/js/sidebar.js"></script>

    </body>

    </html>
<?php } else {
    header("location:login.php");
} ?>