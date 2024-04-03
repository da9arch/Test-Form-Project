<?php

namespace App\Controller;

use App\Form\ProfileFormType;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;


class ProfileController extends AbstractController
{
    #[Route('/profile', name: 'profile')]
    public function index(Request $request): Response
    {
        $form = $this->createForm(ProfileFormType::class);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
        }

        return $this->render('profile/index.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
