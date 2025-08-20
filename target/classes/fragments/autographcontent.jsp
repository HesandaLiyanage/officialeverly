<<<<<<< HEAD
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Everly - Autographs</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>

    <!-- External CSS -->
    <link rel="stylesheet" href="style.css"/>
</head>
<body class="bg-gray-50 text-gray-800">

<div class="min-h-screen flex flex-col">

    <!-- MAIN -->
    <main class="flex-grow container mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="max-w-7xl mx-auto">
            <h2 class="main-title font-bold text-gray-900">Autographs</h2>
            <p class="subtext text-gray-500 mt-2">Share your book with friends and collect heartfelt messages.</p>

            <!-- Autographs Grid -->
            <div class="mt-8 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">

                <%-- Example Card (you can later loop with JSTL if data comes from backend) --%>
                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>
                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">Junior School 2015</h4>
                    <p class="text-xs text-gray-500">July 15, 2015</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">Sunday School</h4>
                    <p class="text-xs text-gray-500">December 06, 2016</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">US</h4>
                    <p class="text-xs text-gray-500">March 15, 2017</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">High School 2018</h4>
                    <p class="text-xs text-gray-500">June 20, 2018</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">Music Club</h4>
                    <p class="text-xs text-gray-500">August 16, 2022</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">University 2025</h4>
                    <p class="text-xs text-gray-500">February 03, 2025</p>
                </div>

                <div class="flex flex-col">
                    <div class="bg-white p-3 rounded-lg shadow-sm">
                        <img alt="Family on a beach" class="rounded-md w-full h-40 object-cover"
                             src="https://lh3.googleusercontent.com/aida-public/AB6AXuCOkkLkn6q0IHk_ELiA7B9qVzAYmQQWCSMi00X3arYxz4eIqPPWNeAjnOZC8EW5BSw8dvw0kznt355eUS9kLL1WPiKY3f0EaXHYPR4_PLbtSt5llZ7dsF5_BgjwCC-uVFXlZAD1PFpm6Pr0h4Bc84AhTXHlyzgfD6iYkIZS_0nmbvOUU5tFn7t3H18Bj5aa-Sr30z25iT_HHQeSzkwf1gDcEuDRre2gMhCFlKk31Ajb5Iwlgjs7QcJ-2GhJUMnz3C-Awz0sEZmEiriX"/>


                    </div>
                    <h4 class="mt-3 text-sm font-semibold text-gray-800">The Cool Gang</h4>
                    <p class="text-xs text-gray-500">Octber 07, 2025</p>
                </div>


            </div>
        </div>
    </main>


    <!-- FIXED ADD BOOK BUTTON -->
    <div class="add-book-container">
        <button class="add-book-btn">Add a Book</button>
    </div>

    <!-- FOOTER -->
    <footer class="bg-gray-50 mt-8">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="flex justify-between items-center text-sm text-gray-500">
                <a class="hover:text-gray-900" href="#">Privacy Policy</a>
                <a class="hover:text-gray-900" href="#">Terms of Service</a>
                <a class="hover:text-gray-900" href="#">Contact Us</a>
            </div>
            <div class="text-center text-xs text-gray-400 mt-6">
                © 2025 Everly. All rights reserved.
            </div>
        </div>
    </footer>

</div>
=======
<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 15-Aug-25
  Time: 2:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

>>>>>>> 1074bcf18c7e71bc3ba935a7b118910f2fbb3da9
</body>
</html>
